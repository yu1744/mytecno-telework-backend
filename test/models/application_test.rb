require "test_helper"

class ApplicationTest < ActiveSupport::TestCase
  setup do
    @application = applications(:pending_application)
    @applicant = users(:applicant_user)
    @manager = users(:manager_user)
    @approver = users(:approver_user)
    @admin = users(:admin_user)
    @other_dept_manager = users(:other_dept_manager)
    @unrelated_user = users(:unrelated_user)
  end

  test "申請者自身は承認できない" do
    assert_not @application.approvable_by?(@applicant)
  end

  test "管理者は承認できる" do
    assert @application.approvable_by?(@admin)
  end

  test "直属のマネージャー(manager)は承認できる" do
    # fixtureで applicant_user の manager は manager_user に設定済み
    assert_equal @manager, @applicant.manager
    assert_equal @manager.department, @applicant.department
    assert @manager.approver?
    
    assert @application.approvable_by?(@manager)
  end

  test "指定された承認者(approver)は承認できる" do
    # fixtureで applicant_user の approver は approver_user に設定済み
    assert_equal @approver, @applicant.approver
    assert_equal @approver.department, @applicant.department
    assert @approver.approver?

    assert @application.approvable_by?(@approver)
  end

  test "別の部署の承認者は承認できない" do
    assert_not_equal @other_dept_manager.department, @applicant.department
    assert @other_dept_manager.approver?

    assert_not @application.approvable_by?(@other_dept_manager)
  end

  test "同一部署だが関係のない承認者は承認できない" do
    # unrelated_user を approver ロールに変更してテストする
    # ただし、fixtureのunrelated_userはgeneralロール
    
    # 新しく同一部署の承認者を作成するか、unrelated_userをモックする
    # ここではわかりやすく、manager_user を使って、manager/approver 関係を外してテストする
    
    @applicant.manager = nil
    @applicant.approver = nil
    @applicant.save!
    
    # manager_user は Dev部の承認者だが、applicant の上司ではなくなった
    assert_equal @manager.department, @applicant.department
    assert @manager.approver?
    assert_not_equal @manager, @applicant.manager
    assert_not_equal @manager, @applicant.approver

    assert_not @application.approvable_by?(@manager)
  end

  test "一般ユーザーは承認できない" do
    assert_not @unrelated_user.approver?
    assert_not @unrelated_user.admin?
    
    assert_not @application.approvable_by?(@unrelated_user)
  end
end
